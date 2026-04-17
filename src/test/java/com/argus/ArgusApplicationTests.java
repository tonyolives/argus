package com.argus;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class ArgusApplicationTests {

    @Autowired private MockMvc mockMvc;

    @Test
    @DisplayName("Application context exposes the health endpoint contract")
    void healthEndpoint_returnsStatusUp() throws Exception {
        mockMvc
                .perform(get("/api/v1/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"));
    }

    @Test
    @DisplayName("OpenAPI docs include the health endpoint")
    void apiDocs_includeHealthEndpoint() throws Exception {
        mockMvc
                .perform(get("/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/api/v1/health")));
    }

    @Test
    @DisplayName("Swagger UI entrypoint redirects to the UI index page")
    void swaggerUi_redirectsToIndex() throws Exception {
        mockMvc
                .perform(get("/swagger-ui.html"))
                .andExpect(status().is3xxRedirection())
                .andExpect(header().string("Location", containsString("/swagger-ui/index.html")));
    }
}
