package com.argus.config;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.argus.controller.HealthController;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(HealthController.class)
@Import(DevCorsConfig.class)
@ActiveProfiles("dev")
@TestPropertySource(properties = "argus.cors.allowed-origins=http://localhost:5173")
class DevCorsConfigTest {

    @Autowired private MockMvc mockMvc;

    @Test
    @DisplayName("Dev profile allows requests from the frontend dev server origin")
    void devProfile_allowsFrontendDevServerOrigin() throws Exception {
        mockMvc.perform(get("/api/v1/health").header("Origin", "http://localhost:5173"))
                .andExpect(status().isOk())
                .andExpect(
                        header().string("Access-Control-Allow-Origin", "http://localhost:5173"));
    }

    @Test
    @DisplayName("Dev profile does not allow unconfigured origins")
    void devProfile_rejectsUnconfiguredOrigin() throws Exception {
        mockMvc.perform(get("/api/v1/health").header("Origin", "http://localhost:3000"))
                .andExpect(status().isForbidden())
                .andExpect(header().doesNotExist("Access-Control-Allow-Origin"));
    }
}
