package com.example.todolist_springapi.rest.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CreateTodoRequest {

    @Schema
    @NotBlank
    private String todoName;

    private boolean completed;

}
