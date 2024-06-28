package com.example.todolist_springapi.mapper;


import com.example.todolist_springapi.model.Todo;
import com.example.todolist_springapi.rest.dto.CreateTodoRequest;
import com.example.todolist_springapi.rest.dto.TodoDto;

public interface TodoMapper {

    Todo toTodo(CreateTodoRequest createTodoRequest);

    TodoDto toTodoDto(Todo todo);
}