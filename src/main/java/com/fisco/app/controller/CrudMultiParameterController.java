package com.fisco.app.controller;

import com.fisco.app.client.CRUDMultiParameterClient;
import com.fisco.app.entity.Person;
import com.fisco.app.entity.ResponseData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;

/**
 * @Classname CrudMultiParameterController
 * @Description 通过接口调用sdk
 * @Date 2021/4/24 22:03
 * @Created by zyt
 */
// TODO: Table crud is not support now
@RestController
@RequestMapping("/multiParameter")
public class CrudMultiParameterController {

    @Autowired
    private CRUDMultiParameterClient crudClient;

    @GetMapping("/query/{name}")
    public ResponseData query(@PathVariable("name") String name) throws Exception {

        return ResponseData.success(crudClient.query(name));
    }


    @PostMapping("/insert")
    public ResponseData insert(@RequestBody String[] params) {
        crudClient.insert(Arrays.asList(params));
        return ResponseData.success("新增成功");
    }


    @PutMapping("/update")
    public ResponseData update(@RequestBody String[] params) {
        crudClient.edit(Arrays.asList(params));
        return ResponseData.success("修改成功");
    }

    @DeleteMapping("/remove/{name}")
    public ResponseData remove(@PathVariable("name") String name) {
        crudClient.remove(name);
        return ResponseData.success("删除成功");
    }
}
