pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./Table.sol";


contract TestCRUD {

    event InsertResult(int256 count);
    event UpdateResult(int256 count);
    event RemoveResult(int256 count);

    Table table;
    string constant TABLE_NAME = "person";
    constructor() public {
        table = Table(0x1001); //The fixed address is 0x1001 for TableFactory
        // the parameters of createTable are tableName,keyField,"vlaueFiled1,vlaueFiled2,vlaueFiled3,..."
        table.createTable(TABLE_NAME, "name", "age,tel");
    }

    //select records
    function select(string memory name)
    public
    view
    returns (string[] memory, string[] memory, string[] memory)
    {

        CompareTriple memory compareTriple1 = CompareTriple("name",name,Comparator.EQ);
        CompareTriple[] memory compareFields = new CompareTriple[](1);
        compareFields[0] = compareTriple1;

        Condition memory condition;
        condition.condFields = compareFields;

        Entry[] memory entries = table.select(TABLE_NAME, condition);
        string[] memory user_name_bytes_list = new string[](uint256(entries.length));
        string[] memory age_list = new string[](uint256(entries.length));
        string[] memory tel_list = new string[](uint256(entries.length));
        if(entries.length > 0){
            for (uint256 i = 0; i < entries.length; ++i) {
                user_name_bytes_list[uint256(i)] = name;
                age_list[uint256(i)] = entries[i].fields[0].value;
                tel_list[uint256(i)] = entries[i].fields[1].value;
            }
        }
        return (user_name_bytes_list, age_list, tel_list);
    }

    //insert records
    function insert(string memory name, string memory age, string memory tel)
    public
    returns (int256)
    {
        KVField memory kv0 = KVField("name",name);
        KVField memory kv1 = KVField("age",age);
        KVField memory kv2 = KVField("tel",tel);
        KVField[] memory KVFields = new KVField[](3);
        KVFields[0] = kv0;
        KVFields[1] = kv1;
        KVFields[2] = kv2;
        Entry memory entry = Entry(KVFields);
        int256 count = table.insert(TABLE_NAME,entry);
        emit InsertResult(count);

        return count;
    }
    //update records
    function update(string memory name, string memory age, string memory tel)
    public
    returns (int256)
    {

        KVField memory kv1 = KVField("age",age);
        KVField memory kv2 = KVField("tel",tel);
        KVField[] memory KVFields = new KVField[](2);
        KVFields[0] = kv1;
        KVFields[1] = kv2;
        Entry memory entry1 = Entry(KVFields);

        CompareTriple memory compareTriple1 = CompareTriple("name",name,Comparator.EQ);
        CompareTriple[] memory compareFields = new CompareTriple[](1);
        compareFields[0] = compareTriple1;

        Condition memory condition;
        condition.condFields = compareFields;
        int256 result = table.update(TABLE_NAME,entry1, condition);
        emit UpdateResult(result);
        return result;
    }
    //remove records
    function remove(string memory name) public returns (int256) {

        CompareTriple memory compareTriple1 = CompareTriple("name",name,Comparator.EQ);
        CompareTriple[] memory compareFields = new CompareTriple[](1);
        compareFields[0] = compareTriple1;

        Condition memory condition;
        condition.condFields = compareFields;
        int256 result = table.remove(TABLE_NAME, condition);
        emit RemoveResult(result);
        return result;
    }
}