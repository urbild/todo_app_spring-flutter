package com.example.todolist_springapi.mapper;

import com.example.todolist_springapi.model.User;
import com.example.todolist_springapi.rest.dto.UserDto;

public interface UserMapper {

    UserDto toUserDto(User user);
}