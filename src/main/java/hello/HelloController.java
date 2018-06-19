package hello;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Value;

@RestController
public class HelloController {
    @Value("${NAME}")
    private String name;


    @RequestMapping("/")
    public String index() {
        return "Greetings from Spring Boot, " + name + "!\n";
    }

}
