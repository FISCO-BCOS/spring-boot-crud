package com.fisco.app.controller;

import com.fisco.app.client.CRUDClient;
import com.fisco.app.entity.Person;
import com.fisco.app.entity.ResponseData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Classname CrudController
 * @Description 通过接口调用sdk
 * @Date 2021/3/25 22:25
 * @Created by zyt
 */
@RestController
public class CrudController {

    @Autowired
    private CRUDClient crudClient;


    @GetMapping("/query/{name}")
    public ResponseData query(@PathVariable("name") String name) throws Exception {

        return ResponseData.success(crudClient.query(name));
    }


    @PostMapping("/insert")
    public ResponseData insert(@RequestBody Person person) {
        crudClient.insert(person.getName(), person.getAge(), person.getTel());
        return ResponseData.success("新增成功");
    }


    @PutMapping("/update")
    public ResponseData update(@RequestBody Person person) {
        crudClient.edit(person.getName(), person.getAge(), person.getTel());
        return ResponseData.success("修改成功");
    }

    @DeleteMapping("/remove/{name}")
    public ResponseData remove(@PathVariable("name") String name) {
        crudClient.remove(name);
        return ResponseData.success("删除成功");
    }
}
