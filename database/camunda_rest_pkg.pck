create or replace package camunda_rest_pkg as

  procedure p_start_process(pi_proc_def_id in varchar2);

end camunda_rest_pkg;
/
create or replace package body camunda_rest_pkg as 

  procedure p_start_process(pi_proc_def_id in varchar2) 
  as
    l_resp_clob clob;
    l_body_clob clob;
  begin

    l_body_clob := '{}';

    apex_web_service.g_request_headers.delete;
    apex_web_service.g_request_headers(1).name := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'application/json';

    l_resp_clob := apex_web_service.make_rest_request(
                      p_url         => 'localhost:8081/engine-rest/process-definition/key/' || pi_proc_def_id || '/start'
                    , p_http_method => 'POST'
                    , p_body        => l_body_clob
                    );

    dbms_output.put_line(l_resp_clob);   

  exception 
    when others then 
      raise;
  end p_start_process;

end camunda_rest_pkg;