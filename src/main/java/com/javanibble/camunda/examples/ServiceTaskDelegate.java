package com.javanibble.camunda.examples;

import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component("servicetaskdelegate")
public class ServiceTaskDelegate implements JavaDelegate {

    private final Logger LOGGER = LoggerFactory.getLogger(ServiceTaskDelegate.class.getName());

    public void execute(DelegateExecution execution) throws Exception {
        String activityId = execution.getCurrentActivityId();
        String processInstanceId = execution.getProcessInstanceId();

        if ("service-task-1".equals(activityId)) {
            execution.getProcessEngine().getRuntimeService().setVariable(processInstanceId, "conditionalEventSubProcess1", true);

        } else if ("service-task-2".equals(activityId)) {
            execution.getProcessEngine().getRuntimeService().setVariable(processInstanceId, "conditionalEventSubProcess2", true);

        } else {
            LOGGER.info("Something went wrong !!!!");
        }
    }
}
