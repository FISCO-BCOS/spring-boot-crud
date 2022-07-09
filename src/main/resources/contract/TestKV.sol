// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./Table.sol";

contract TestKV {
    string constant TABLE_NAME = "person_kv";
    TableManager tm;
    KVTable kv_table;

    event SetEvent(int256 count);
    constructor () public {
        tm = TableManager(address(0x1002));

        // create kv table
        tm.createKVTable(TABLE_NAME, "name", "age");

        // get table address
        address t_address = tm.openTable(TABLE_NAME);
        kv_table = KVTable(t_address);
    }

    function get(string memory name) public view returns (bool, string memory)
    {
        bool ok = false;
        string memory value;
        (ok, value) = kv_table.get(name);
        return (ok, value);
    }

    function set(string memory name, string memory age) public returns (int256) {
        int32 result = kv_table.set(name, age);
        emit SetEvent(result);
        return result;
    }
}
