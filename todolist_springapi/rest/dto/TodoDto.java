package com.example.todolist_springapi.rest.dto;

import java.time.ZonedDateTime;

public record TodoDto(String id, String todoName, TodoDto.UserDto user, boolean completed, ZonedDateTime createdAt) {

    public record UserDto(String username) {
    }
}