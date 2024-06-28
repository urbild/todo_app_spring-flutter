package com.example.todolist_springapi.rest.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SignUpRequest {

    @Schema
    @NotBlank
    private String username;

    @Schema
    @NotBlank
    private String password;

    @Schema
    @Email
    private String email;
}
