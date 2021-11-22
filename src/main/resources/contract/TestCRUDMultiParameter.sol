pragma solidity>=0.4.24 <0.6.11;
pragma experimental ABIEncoderV2;

import "./Table.sol";


contract TestCRUDMultiParameter {

    event InsertResult(int256 count);
    event UpdateResult(int256 count);
    event RemoveResult(int256 count);

    Table table;
    string constant TABLE_NAME = "person";
    //定义属性，多参数通过数组解决,数组第一个值为主键
    string []  properties = ["name","age","tel"];
    constructor() public {
        table = Table(0x1001); //The fixed address is 0x1001 for TableFactory
        // the parameters of createTable are tableName,keyField,"vlaueFiled1,vlaueFiled2,vlaueFiled3,..."
        table.createTable(TABLE_NAME, "name", "age,tel");
    }

    //插入数据
    function insert(string[] memory entity)
    public
    returns (int256)
    {
        require(entity.length == 3, "entity length mismatch");
        KVField[] memory KVFields = new KVField[](3);
        for (uint256 i = 0; i < properties.length; ++i) {
            KVField memory kv = KVField(properties[i], entity[i]);
            KVFields[i] = kv;
        }
        Entry memory entry = Entry(KVFields);

        int256 count = table.insert(TABLE_NAME,entry);
        emit InsertResult(count);

        return count;
    }

    //查询数据
    function select(string memory name)
    public
    view
    returns (string[] memory,string[] memory,string[] memory)
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

    //修改数据
    function update(string[] memory entity)
    public
    returns (int256)
    {
        require(entity.length == 3, "entity length mismatch");
        KVField[] memory KVFields = new KVField[](2);

        for (uint256 i = 1; i < entity.length; ++i) {
            KVField memory kv = KVField(properties[i], entity[i]);
            KVFields[i-1] = kv;
        }
        Entry memory entry = Entry(KVFields);

        CompareTriple memory compareTriple1 = CompareTriple(properties[0], entity[0],Comparator.EQ);
        CompareTriple[] memory compareFields = new CompareTriple[](1);
        compareFields[0] = compareTriple1;

        Condition memory condition;
        condition.condFields = compareFields;

        int256 count = table.update(TABLE_NAME,entry, condition);
        emit UpdateResult(count);

        return count;
    }

    //删除数据
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