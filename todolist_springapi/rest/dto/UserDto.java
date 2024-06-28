package com.example.todolist_springapi.rest.dto;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

public record UserDto(UUID id, String username, String email, String role, List<TodoDto> orders) {

    public record TodoDto(String id, String todoName, Boolean completed, ZonedDateTime createdAt) {
    }
}