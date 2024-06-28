package com.example.todolist_springapi.mapper;


import com.example.todolist_springapi.model.Todo;
import com.example.todolist_springapi.model.User;
import com.example.todolist_springapi.rest.dto.UserDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserMapperImpl implements UserMapper {

    @Override
    public UserDto toUserDto(User user) {
        if (user == null) {
            return null;
        }
        List<UserDto.TodoDto> todos = user.getTodos().stream().map(this::toUserDtoTodoDto).toList();
        return new UserDto(user.getId(), user.getUsername(), user.getEmail(), user.getRole(), todos);
    }

    private UserDto.TodoDto toUserDtoTodoDto(Todo todo) {
        if (todo == null) {
            return null;
        }
        return new UserDto.TodoDto(todo.getId(), todo.getTodoName(), todo.isCompleted(), todo.getCreatedAt());
    }
}
