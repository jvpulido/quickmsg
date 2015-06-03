import org.json.simple.*;
import java.util.*;

class ServiceImpl extends Service {
    public ServiceImpl(String srv_name) {
        super(srv_name);
    }
    
    public Long add_ints(List<Long> l) {
        long result = (long)0;
        for (int i=0 ; i < l.size(); i++) {
            System.out.println(l.get(i));
            result+=l.get(i);
        }
        return result;
    }

    public String service_impl(Message req) {
        System.out.println("Java inherited subscriber callback");
        System.out.println(req.getMsg());
        Object obj=JSONValue.parse(req.getMsg());
        JSONObject jsonreq = (JSONObject) obj;
        JSONArray ints_to_add=(JSONArray) jsonreq.get("ints_to_add");
        Long result = add_ints(ints_to_add);
        JSONObject jsonresp = new JSONObject();
        jsonresp.put("ints_to_add",ints_to_add);
        jsonresp.put("result",result);
        return JSONObject.toJSONString(jsonresp);
    }

}

public class test_service {
    static {
        String lib_name = "quickmsg_java";
        try {
            System.loadLibrary(lib_name);
        } catch (UnsatisfiedLinkError e) {
            System.err.println("Could not find "+lib_name+". Check Library Search Path");
            System.exit(1);
        }
    }

    public static void main(String[] argv) {
        ServiceImpl svc = new ServiceImpl("add");
        svc.spin();
    }
}
