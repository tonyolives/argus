package com.argus.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI argusOpenAPI() {
        return new OpenAPI()
                .info(
                        new Info()
                                .title("Argus API")
                                .description(
                                        "Real-Time Global OSINT Monitoring Platform — REST API")
                                .version("0.0.1")
                                .contact(new Contact().name("Argus Team")));
    }
}
