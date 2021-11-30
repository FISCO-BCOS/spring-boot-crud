package com.fisco.app.client;

import com.fisco.app.common.CommonClientMultiParameter;
import com.fisco.app.contract.TestCRUDMultiParameter;
import com.fisco.app.contract.TestKVMultiParameter;
import com.fisco.app.utils.SpringUtils;
import org.fisco.bcos.sdk.BcosSDK;
import org.fisco.bcos.sdk.codec.datatypes.generated.tuples.generated.Tuple3;
import org.fisco.bcos.sdk.model.TransactionReceipt;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

/**
 * @Classname CRUDClientMultiParameter
 * @Description sdk客户端，可以不使用ApplicationRunner，这里是让spring容器启动部署合约
 * @Date 2021/4/24 21:42
 * @Created by zyt
 */
@Service
public class KVMultiParameterClient extends CommonClientMultiParameter implements ApplicationRunner {
    public boolean set(List<String> params) {
        TestKVMultiParameter testKVMultiParameter = (TestKVMultiParameter) getContractMap().get("TestKVMultiParameter");
        TransactionReceipt receipt = testKVMultiParameter.set(params);
        logger.info("KVMultiParameterClient");
        logger.info("结果：{}", receipt);
        return true;
    }

    public List<Tuple3<String, String, String>> get(String name) throws ContractException {
        TestKVMultiParameter testKVMultiParameter = (TestKVMultiParameter) getContractMap().get("TestKVMultiParameter");
        List<Tuple3<String, String, String>> result = Collections.singletonList(testKVMultiParameter.get(name));
        logger.info("KVMultiParameterClient");
        logger.info("结果：{}", result);
        return result;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        BcosSDK sdk = SpringUtils.getBean("bcosSDK");
        deploy("TestKVMultiParameter", TestKVMultiParameter.class, sdk);
    }
}
