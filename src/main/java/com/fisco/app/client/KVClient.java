package com.fisco.app.client;

import com.fisco.app.common.CommonClient;
import com.fisco.app.contract.TestKV;
import com.fisco.app.utils.SpringUtils;
import org.fisco.bcos.sdk.v3.BcosSDK;
import org.fisco.bcos.sdk.v3.client.Client;
import org.fisco.bcos.sdk.v3.codec.datatypes.generated.tuples.generated.Tuple2;
import org.fisco.bcos.sdk.v3.codec.datatypes.generated.tuples.generated.Tuple3;
import org.fisco.bcos.sdk.v3.model.TransactionReceipt;
import org.fisco.bcos.sdk.v3.transaction.model.exception.ContractException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Classname KVClient
 * @Description sdk客户端，可以不使用ApplicationRunner，这里是让spring容器启动部署合约
 * @Date 2021/3/25 21:45
 * @Created by zyt
 */
@Service
public class KVClient extends CommonClient implements ApplicationRunner {

    public static final Logger logger = LoggerFactory.getLogger(KVClient.class.getName());


    public void set(String name, String age) {

        TestKV testKV = (TestKV) getContractMap().get("TestKV");
        TransactionReceipt receipt = testKV.set(name, age);
        logger.info("KVClient");
        logger.info("结果：{}", receipt);

    }

    public Tuple2<Boolean, String> get(String name) throws ContractException {

        TestKV testKV = (TestKV) getContractMap().get("TestKV");
        Tuple2<Boolean, String> getValue = testKV.get(name);
        logger.info("KVClient");
        logger.info("结果：{}", getValue);
        return getValue;

    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        BcosSDK sdk = SpringUtils.getBean("bcosSDK");
        deploy("TestKV", TestKV.class, sdk);
    }
}
