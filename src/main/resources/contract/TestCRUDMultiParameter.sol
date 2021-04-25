pragma solidity>=0.4.24 <0.6.11;
pragma experimental ABIEncoderV2;

import "./Table.sol";


contract TestCRUDMultiParameter {
    
    event CreateResult(int256 count);
    event InsertResult(int256 count);
    event UpdateResult(int256 count);
    event RemoveResult(int256 count);
    
    TableFactory tableFactory;
    string constant TABLE_NAME = "person";
    //定义属性，多参数通过数组解决,数组第一个值为主键
    string []  properties = ["name","age","tel"];
    constructor() public {
        
        tableFactory = TableFactory(0x1001); 
        tableFactory.createTable(TABLE_NAME, "name", "age,tel");
       
    }

     //插入数据
    function insert(string [] entity)
    public
    returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);
        
        Entry entry = table.newEntry();
        for (uint256 i = 0; i < properties.length; ++i) {
            entry.set(properties[i], entity[i]);
        }

        int256 count = table.insert(entity[0], entry);
        emit InsertResult(count);

        return count;
    }
    
     //查询数据
    function select(string memory name)
    public
    view
    returns (string[] memory,string[] memory,string[] memory)
    {
        Table table = tableFactory.openTable(TABLE_NAME);

        Condition condition = table.newCondition();

        Entries entries = table.select(name, condition);
        string[] memory user_name_bytes_list = new string[](uint256(entries.size()));
        string[] memory age_list = new string[](uint256(entries.size()));
        string[] memory tel_list = new string[](uint256(entries.size()));
     
        for (int256 i = 0; i <entries.size(); ++i) {
            Entry entry = entries.get(i);
            user_name_bytes_list[uint256(i)] = entry.getString(properties[0]);
            age_list[uint256(i)] = entry.getString(properties[1]);
            tel_list[uint256(i)] = entry.getString(properties[2]);
        }

        return (user_name_bytes_list,age_list,tel_list);
    }
    
     //修改数据
    function update(string [] entity)
    public
    returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);

        Entry entry = table.newEntry();
        for (uint256 i = 1; i < entity.length; ++i) {
            entry.set(properties[i], entity[i]);
        }

        Condition condition = table.newCondition();
        condition.EQ(properties[0], entity[0]);

        int256 count = table.update(entity[0], entry, condition);
        emit UpdateResult(count);

        return count;
    }
    
     //删除数据
    function remove(string memory name) public returns (int256) {
        Table table = tableFactory.openTable(TABLE_NAME);

        Condition condition = table.newCondition();
        condition.EQ(properties[0], name);

        int256 count = table.remove(name, condition);
        emit RemoveResult(count);

        return count;
    }
    
   
}