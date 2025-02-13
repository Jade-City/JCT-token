// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/JadeCity.sol";

contract JadeCityTest is Test {
    JadeCity token;
    address user = address(0x123);

    function setUp() public {
        token = new JadeCity(user); // Передаем получателя в конструктор
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), 1_000_000_000 * 10 ** token.decimals());
    }

    function testBurn() public {
        vm.startPrank(user);
        token.burn(50 * 10 ** token.decimals());
        vm.stopPrank();

        uint256 expectedBalance = 1_000_000_000 * 10 ** token.decimals() - 50 * 10 ** token.decimals();
        uint256 actualBalance = token.balanceOf(user);
        assertEq(actualBalance, expectedBalance, "User balance after burn is incorrect");
    }

    function testPermit() public {
        uint256 privateKey = 0x123456;
        address owner = vm.addr(privateKey);
        vm.startPrank(owner);
        token.approve(address(this), 100);
        assertEq(token.allowance(owner, address(this)), 100);
        vm.stopPrank();
    }

    function testTransfer() public {
        address recipient = address(0x456);
        vm.startPrank(user);
        token.transfer(recipient, 25 * 10 ** token.decimals());
        vm.stopPrank();
        assertEq(
            token.balanceOf(recipient), 25 * 10 ** token.decimals(), "Recipient balance after transfer is incorrect"
        );
    }

    function testAllowanceAndApproval() public {
        address spender = address(0x789);
        vm.startPrank(user);
        token.approve(spender, 100 * 10 ** token.decimals());
        vm.stopPrank();
        assertEq(token.allowance(user, spender), 100 * 10 ** token.decimals(), "Allowance is incorrect");
    }

    function testTransferFrom() public {
        address spender = address(this);
        vm.startPrank(user);
        token.approve(spender, 100 * 10 ** token.decimals());
        vm.stopPrank();
        token.transferFrom(user, address(0x456), 50 * 10 ** token.decimals());
        assertEq(token.balanceOf(address(0x456)), 50 * 10 ** token.decimals(), "TransferFrom did not work correctly");
    }

    function testPermitAndTransferFrom() public {
        uint256 privateKey = 0x123456;
        address owner = vm.addr(privateKey);
        address spender = address(this);
        uint256 amount = 50 * 10 ** token.decimals();
        uint256 deadline = block.timestamp + 1 days;

        // ✅ Ensure owner has tokens before calling permit()
        vm.startPrank(user);
        token.transfer(owner, amount);
        vm.stopPrank();

        bytes32 digest = getPermitDigest(owner, spender, amount, deadline);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);

        vm.prank(owner);
        token.permit(owner, spender, amount, deadline, v, r, s);

        token.transferFrom(owner, address(0x456), amount);
        assertEq(token.balanceOf(address(0x456)), amount, "Permit transferFrom did not work correctly");
    }

    function getPermitDigest(address owner, address spender, uint256 value, uint256 deadline)
        internal
        view
        returns (bytes32)
    {
        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                owner,
                spender,
                value,
                token.nonces(owner),
                deadline
            )
        );
        return keccak256(abi.encodePacked("\x19\x01", token.DOMAIN_SEPARATOR(), structHash));
    }
}
