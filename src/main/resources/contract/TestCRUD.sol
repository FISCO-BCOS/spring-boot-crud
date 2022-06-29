// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.10 <0.8.20;
pragma experimental ABIEncoderV2;

import "./Table.sol";

contract TestCRUD {

    event CreateResult(int256 count);
    event InsertResult(int256 count);
    event UpdateResult(int256 count);
    event RemoveResult(int256 count);

    TableManager constant tm = TableManager(address(0x1002));
    Table table;
    string constant TABLE_NAME = "person";
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

    //insert records
    function insert(string memory name, string memory age, string memory tel)
    public
    returns (int256)
    {
        string[] memory columns = new string[](2);
        columns[0] = age;
        columns[1] = tel;
        Entry memory entry = Entry(name, columns);

        int256 count = table.insert(entry);
        emit InsertResult(count);
        return count;
    }

    //update records
    function update(string memory name, string memory age, string memory tel)
    public
    returns (int256)
    {
        UpdateField[] memory updateFields = new UpdateField[](2);
        updateFields[0] = UpdateField("age", age);
        updateFields[1] = UpdateField("tel", tel);

        int256 result = table.update(name, updateFields);
        emit UpdateResult(result);
        return result;
    }
    //remove records
    function remove(string memory name) public returns (int256) {
        int256 result = table.remove(name);
        emit RemoveResult(result);
        return result;
    }
}