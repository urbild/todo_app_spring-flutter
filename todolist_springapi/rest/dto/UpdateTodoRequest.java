package com.example.todolist_springapi.rest.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateTodoRequest {

    @NotNull
    private String todoName;

    private boolean completed;
}
