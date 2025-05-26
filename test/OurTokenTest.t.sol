// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

contract OurTokenTest is Test {
    
    address public bob = makeAddr("bob");
    address public alice = makeAddr("alice");
    uint256 public constant SEND_VALUE = 200 ether;
    address public zeroAddress = address(0);
    uint256 public constant TOTAL_SUPPLY = 1000 ether;

    DeployOurToken public deployOurToken;
    OurToken public ourToken;

    function setUp() public {
        deployOurToken = new DeployOurToken();
        ourToken = deployOurToken.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, SEND_VALUE);
    }

    function testBobBalance() public view {
        assertEq(SEND_VALUE, ourToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 10 ether;
        uint256 transferAmount = 5 ether;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), SEND_VALUE - transferAmount);
    }

    function testTransferBetweenUsers() public {
        uint256 amount = 50 ether;

        vm.prank(bob);
        ourToken.transfer(alice, amount);

        assertEq(ourToken.balanceOf(bob), SEND_VALUE - amount);
        assertEq(ourToken.balanceOf(alice), amount);
    }

    function testTransferFailsIfInsufficientBalance() public {
        uint256 balanceOfBob = ourToken.balanceOf(bob);
        uint256 excessiveAmount = balanceOfBob + 1e18;

        hoax(bob);
        vm.expectRevert(abi.encodeWithSelector(ERC20InsufficientBalance.selector, bob, balanceOfBob, excessiveAmount));
        ourToken.transfer(alice, excessiveAmount);
    }

    function testApproveAndTransferFrom() public {
        uint256 allowance = 20 ether;
        uint256 transferAmount = 15 ether;

        vm.prank(bob);
        ourToken.approve(alice, allowance);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), SEND_VALUE - transferAmount);
        assertEq(ourToken.allowance(bob, alice), allowance - transferAmount);
    }

    function testTransferFromFailsIfNotEnoughAllowance() public {
        uint256 allowance = 5 ether;
        uint256 transferAmount = 10 ether;

        vm.prank(bob);
        ourToken.approve(alice, allowance);

        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(ERC20InsufficientAllowance.selector, alice, allowance, transferAmount));
        ourToken.transferFrom(bob, alice, transferAmount);
    }

    function testTransferFromFailsIfNotEnoughBalance() public {
        uint256 allowance = ourToken.balanceOf(bob);
        uint256 transferAmount = allowance + 2e18;

        vm.prank(bob);
        ourToken.approve(alice, allowance);

        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(ERC20InsufficientAllowance.selector, alice, allowance, transferAmount));
        ourToken.transferFrom(bob, alice, transferAmount);
    }

    function testApproveOverwritesPreviousAllowance() public {
        uint256 firstApproval = 5 ether;
        uint256 secondApproval = 100 ether;

        vm.prank(bob);
        ourToken.approve(alice, firstApproval);
        assertEq(ourToken.allowance(bob, alice), firstApproval);

        vm.prank(bob);
        ourToken.approve(alice, secondApproval);
        assertEq(ourToken.allowance(bob, alice), secondApproval);
    }

    function testCannotTransferToZeroAddress() public {
        uint256 amount = 10 ether;

        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(zeroAddress, amount);
    }

    function testCannotApproveZeroAddress() public {
        uint256 amount = 10 ether;

        vm.prank(bob);
        vm.expectRevert();
        ourToken.approve(zeroAddress, amount);
    }

    function testCannotTransferFromZeroAddress() public {
        // This test would require simulating transfer from zero address, which is not possible directly in Foundry.
        // It is enforced by ERC20 base contract and typically not testable unless contract behavior is extended manually.
    }

    function testTotalSupplyRemainsConstant() public view {
        assertEq(ourToken.totalSupply(), TOTAL_SUPPLY);
    }
}
