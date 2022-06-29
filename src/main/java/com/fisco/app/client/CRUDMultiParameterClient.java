package com.fisco.app.client;

import com.fisco.app.common.CommonClientMultiParameter;
import com.fisco.app.contract.TestCRUDMultiParameter;
import com.fisco.app.utils.SpringUtils;
import org.fisco.bcos.sdk.v3.BcosSDK;
import org.fisco.bcos.sdk.v3.model.TransactionReceipt;
import org.fisco.bcos.sdk.v3.transaction.model.exception.ContractException;
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
public class CRUDMultiParameterClient extends CommonClientMultiParameter implements ApplicationRunner {
    public boolean insert(List<String> params) {
        TestCRUDMultiParameter testCRUDMultiParameter = (TestCRUDMultiParameter) getContractMap().get("TestCRUDMultiParameter");
        TransactionReceipt receipt = testCRUDMultiParameter.insert(params);
        logger.info("调用CRUDClientMultiParameter的insert方法");
        logger.info("结果：{}", receipt);
        return true;
    }

    public List query(String name) throws ContractException {
        TestCRUDMultiParameter testCRUDMultiParameter = (TestCRUDMultiParameter) getContractMap().get("TestCRUDMultiParameter");
        List result = Collections.singletonList(testCRUDMultiParameter.select(name));
        logger.info("调用CRUDClientMultiParameter的query方法");
        logger.info("结果：{}", result);
        return result;
    }

    public boolean edit(List<String> params) {
        TestCRUDMultiParameter testCRUDMultiParameter = (TestCRUDMultiParameter) getContractMap().get("TestCRUDMultiParameter");
        TransactionReceipt receipt = testCRUDMultiParameter.update(params);
        logger.info("调用CRUDClientMultiParameter的edit方法");
        logger.info("结果：{}",receipt);
        return true;
    }

    public boolean remove(String name) {
        TestCRUDMultiParameter testCRUDMultiParameter = (TestCRUDMultiParameter) getContractMap().get("TestCRUDMultiParameter");
        TransactionReceipt receipt = testCRUDMultiParameter.remove(name);
        logger.info("调用CRUDClientMultiParameter的remove方法");
        logger.info("结果：{}",receipt);
        return true;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        BcosSDK sdk = SpringUtils.getBean("bcosSDK");
        deploy("TestCRUDMultiParameter", TestCRUDMultiParameter.class, sdk);
    }
}
