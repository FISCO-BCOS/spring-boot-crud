package com.fisco.app.controller;

import com.fisco.app.client.KVMultiParameterClient;
import com.fisco.app.entity.ResponseData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;

/**
 * @Classname KVMultiParameterController
 * @Description 通过接口调用sdk
 * @Date 2021/4/24 22:03
 * @Created by zyt
 */
@RestController
@RequestMapping("/multiParameter")
public class KVMultiParameterController {

    @Autowired
    private KVMultiParameterClient kvMultiParameterClient;

    @GetMapping("/get/{name}")
    public ResponseData get(@PathVariable("name") String name) throws Exception {

        return ResponseData.success(kvMultiParameterClient.get(name));
    }

    @PostMapping("/set")
    public ResponseData insert(@RequestBody String[] params) {
        kvMultiParameterClient.set(Arrays.asList(params));
        return ResponseData.success("新增成功");
    }
}
