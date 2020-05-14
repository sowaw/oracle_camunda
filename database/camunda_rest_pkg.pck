create or replace package camunda_rest_pkg as

  procedure p_start_process(pi_proc_def_id in varchar2);

  -- adapt to function returning clob?
  procedure p_list_tasks(pi_proc_def_key in varchar2);

  procedure p_complete_task(pi_task_id in varchar2);

end camunda_rest_pkg;
/
create or replace package body camunda_rest_pkg as

  -- https://docs.camunda.org/manual/7.12/reference/rest/process-definition/post-start-process-instance/
  procedure p_start_process(pi_proc_def_id in varchar2) as
    l_resp_clob clob;
    l_body_clob clob;
  begin
  
    l_body_clob := '{}';
  
    apex_web_service.g_request_headers.delete;
    apex_web_service.g_request_headers(1).name := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'application/json';
  
    l_resp_clob := apex_web_service.make_rest_request(p_url         => 'localhost:8081/engine-rest/process-definition/key/' ||
                                                                       pi_proc_def_id ||
                                                                       '/start',
                                                      p_http_method => 'POST',
                                                      p_body        => l_body_clob);
  
    dbms_output.put_line(l_resp_clob);
  
  exception
    when others then
      raise;
  end p_start_process;

  procedure p_list_tasks(pi_proc_def_key in varchar2) as
    l_resp_clob clob;
  begin
  
    l_resp_clob := apex_web_service.make_rest_request(p_url         => 'localhost:8081/engine-rest/task?processDefinitionKey=' ||
                                                                       pi_proc_def_key,
                                                      p_http_method => 'GET');
  
    apex_json.parse(l_resp_clob);
  
    dbms_output.put_line(l_resp_clob);
  
  exception
    when others then
      raise;
  end p_list_tasks;

  procedure p_complete_task(pi_task_id in varchar2) as
    l_body_clob clob;
    l_resp_clob clob;
  begin
  
    apex_json.initialize_clob_output;
    apex_json.open_object();
    apex_json.open_object('variables');
    apex_json.open_object(p_name => 'teamName');
    apex_json.write('value', 'Barcelona');
    apex_json.close_object();
    apex_json.close_object();
    apex_json.close_object();
    
    l_body_clob := apex_json.get_clob_output;
  
    apex_web_service.g_request_headers.delete;
    apex_web_service.g_request_headers(1).name := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'application/json';
  
    l_resp_clob := apex_web_service.make_rest_request(p_url         => 'localhost:8081/engine-rest/task/' ||
                                                                       pi_task_id || '/complete',
                                                      p_http_method => 'POST',
                                                      p_body        => l_body_clob);
  
    dbms_output.put_line(l_resp_clob);
    dbms_output.put_line(apex_web_service.g_status_code);
  
  exception
    when others then
      raise;
  end p_complete_task;

end camunda_rest_pkg;
/
