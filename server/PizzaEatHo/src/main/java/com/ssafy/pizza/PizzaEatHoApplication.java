package com.ssafy.pizza;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.tags.Tag;

@SpringBootApplication
@MapperScan(basePackages = "com.ssafy.pizza.model.dao")
public class PizzaEatHoApplication {


	public static void main(String[] args) {
		SpringApplication.run(PizzaEatHoApplication.class, args);
	}
	
   @Bean
    public OpenAPI postsApi() {
        Info info = new Info()
               .title("PizzaEatHo API")
               .description("<h3>Rest API</h3><br>"
               		+ "<img src=\"/imgs/ssafy_logo.png\" width=\"200\">")
               .contact(new Contact().name("ssafy").email("ssafy@ssafy.com"))
               .license(new License().name("SSAFY License").url("https://www.ssafy.com/ksp/jsp/swp/etc/swpPrivacy.jsp"))
               .version("1.0");
        
        return new OpenAPI()
                .info(info);
    }

}


