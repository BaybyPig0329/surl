// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Surl} from "src/Surl.sol";
import {strings} from "solidity-stringutils/strings.sol";

contract SurlTest is Test {
    using Surl for *;
    using strings for *;

    function setUp() public {}

    function testGet() public {
        (uint256 status, bytes memory data) = "https://jsonplaceholder.typicode.com/todos/1".get();

        assertEq(status, 200);
        assertEq(string(data), '{  "userId": 1,  "id": 1,  "title": "delectus aut autem",  "completed": false}');
    }

    function testGetOptions() public {
        string[] memory headers = new string[](2);
        headers[0] = "accept: application/json";
        headers[1] = "Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==";
        (uint256 status, bytes memory data) = "https://httpbin.org/headers".get(headers);

        assertEq(status, 200);

        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(("QWxhZGRpbjpvcGVuIHNlc2FtZQ==").toSlice()));
        assertTrue(responseText.contains(("application/json").toSlice()));
    }

    function testPostFormData() public {
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/x-www-form-urlencoded";
        (uint256 status, bytes memory data) = "https://httpbin.org/post".post(headers, "formfield=myemail@ethereum.org");

        assertEq(status, 200);

        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(("formfield").toSlice()));
        assertTrue(responseText.contains(("myemail@ethereum.org").toSlice()));
    }

    function testPostJson() public {
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";
        (uint256 status, bytes memory data) = "https://httpbin.org/post".post(headers, '{"foo": "bar"}');

        assertEq(status, 200);
        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(("foo").toSlice()));
        assertTrue(responseText.contains(("bar").toSlice()));
    }

    function testPut() public {
        (uint256 status,) = "https://httpbin.org/put".put();

        assertEq(status, 200);
    }

    function testPutJson() public {
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";
        (uint256 status, bytes memory data) = "https://httpbin.org/put".put(headers, '{"foo": "bar"}');

        assertEq(status, 200);
        strings.slice memory responseText = string(data).toSlice();
        assertTrue(responseText.contains(("foo").toSlice()));
        assertTrue(responseText.contains(("bar").toSlice()));
    }

    function testDelete() public {
        (uint256 status,) = "https://httpbin.org/delete".del();

        assertEq(status, 200);
    }

    function testPatch() public {
        (uint256 status,) = "https://httpbin.org/patch".patch();

        assertEq(status, 200);
    }

    function test1InchAPI() public {
        string memory url = "https://api.1inch.io/v5.0/1/swap";
        string memory params = string.concat(
            "?fromAddress=",
            vm.toString(address(0)),
            "&fromTokenAddress=",
            vm.toString(address(0x6B175474E89094C44Da98b954EedeAC495271d0F)),
            "&toTokenAddress=",
            vm.toString(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)),
            "&amount=",
            vm.toString(uint256(100 ether)),
            "&slippage=",
            vm.toString(uint256(3)),
            "&allowPartialFill=false",
            "&disableEstimate=true"
        );

        string[] memory headers = new string[](2);
        headers[0] = "accept: application/json";
        headers[1] =
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15";

        string memory request = string.concat(url, params);
        (uint256 status, bytes memory data) = request.get(headers);

        console2.log(string(data));
        assertEq(status, 200);
    }
}
