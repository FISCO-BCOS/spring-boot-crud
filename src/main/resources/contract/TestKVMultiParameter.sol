// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./KVTable.sol";


contract TestKVMultiParameter {

    event SetEvent(int256 count);

    KVTable kv_table;
    string constant TABLE_NAME = "person";
    //定义属性，多参数通过数组解决,数组第一个值为主键
    string []  properties = ["name","age","tel"];
    constructor() public {
        kv_table = KVTable(0x1009); //The fixed address is 0x1009 for TableFactory
        // the parameters of createTable are tableName,keyField,"vlaueFiled1,vlaueFiled2,vlaueFiled3,..."
        kv_table.createTable(TABLE_NAME, "name", "age,tel");
    }

    //插入数据
    function set(string[] memory entity)
    public
    returns (int256)
    {
        require(entity.length == 3, "entity length mismatch");
        KVField[] memory KVFields = new KVField[](2);
        for (uint256 i = 1; i < properties.length; ++i) {
            KVField memory kv = KVField(properties[i], entity[i]);
            KVFields[i-1] = kv;
        }
        Entry memory entry = Entry(KVFields);

        int256 count = kv_table.set(TABLE_NAME, entity[0], entry);
        emit SetEvent(count);

        return count;
    }

    //查询数据
    function get(string memory name)
    public
    view
    returns (string memory,string memory,string memory)
    {
        bool ok = false;
        Entry memory entry;
        (ok, entry) = kv_table.get(TABLE_NAME, name);
        string memory age;
        string memory tel;
        if (ok) {
            age = entry.fields[0].value;
            tel = entry.fields[1].value;
            return (name, age, tel);
        }
        return ("","","");
    }
}