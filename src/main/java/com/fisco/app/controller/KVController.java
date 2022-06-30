package com.fisco.app.controller;

import com.fisco.app.client.KVClient;
import com.fisco.app.entity.Person;
import com.fisco.app.entity.ResponseData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Classname KVController
 * @Description 通过接口调用sdk
 * @Date 2021/3/25 22:25
 * @Created by zyt
 */
@RestController
public class KVController {

    @Autowired
    private KVClient kvClient;

    @GetMapping("/get/{name}")
    public ResponseData get(@PathVariable("name") String name) throws Exception {

        return ResponseData.success(kvClient.get(name));
    }

    @PostMapping("/set")
    public ResponseData set(@RequestBody Person person) {
        kvClient.set(person.getName(), person.getAge());
        return ResponseData.success("新增成功");
    }
}
