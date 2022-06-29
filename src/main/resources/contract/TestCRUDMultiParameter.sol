// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.10 <0.8.20;
pragma experimental ABIEncoderV2;

import "./Table.sol";

contract TestCRUDMultiParameter {

    event CreateResult(int256 count);
    event InsertResult(int256 count);
    event UpdateResult(int256 count);
    event RemoveResult(int256 count);

    string constant TABLE_NAME = "person_multi";
    //定义属性，多参数通过数组解决,数组第一个值为主键
    string []  properties = ["name", "age", "tel"];
    TableManager constant tm = TableManager(address(0x1002));
    Table table;
    constructor() public {
        // create table
        string[] memory columnNames = new string[](2);
        columnNames[0] = "age";
        columnNames[1] = "tel";
        TableInfo memory tf = TableInfo("name", columnNames);

        tm.createTable(TABLE_NAME, tf);
        address t_address = tm.openTable(TABLE_NAME);
        require(t_address != address(0x0), "create table failed");
        table = Table(t_address);
    }

    //select records
    function select(string memory name)
    public
    view
    returns (string memory, string memory, string memory)
    {
        Entry memory entry = table.select(name);

        string memory age;
        string memory tel;
        if (entry.fields.length == 2) {
            age = entry.fields[0];
            tel = entry.fields[1];
        }
        return (name, age, tel);
    }

    //插入数据
    function insert(string[] memory entity)
    public
    returns (int256)
    {
        require(entity.length >= 3);
        string[] memory columns = new string[](2);
        string memory name = entity[0];
        columns[0] = entity[1];
        columns[1] = entity[2];

        Entry memory entry = Entry(name, columns);

        int256 count = table.insert(entry);
        emit InsertResult(count);
        return count;
    }

    //修改数据
    function update(string[] memory entity)
    public
    returns (int256)
    {
        require(entity.length >= 3);
        UpdateField[] memory updateFields = new UpdateField[](2);
        updateFields[0] = UpdateField("age", entity[1]);
        updateFields[1] = UpdateField("tel", entity[2]);

        int256 result = table.update(entity[0], updateFields);
        emit UpdateResult(result);
        return result;
    }

    //删除数据
    function remove(string memory name) public returns (int256) {
        int256 result = table.remove(name);
        emit RemoveResult(result);
        return result;
    }
}