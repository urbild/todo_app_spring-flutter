package com.example.todolist_springapi.service;

import com.example.todolist_springapi.model.Todo;
import com.example.todolist_springapi.model.User;

import java.util.List;
import java.util.UUID;

public interface TodoService {

    List<Todo> getTodos();

    List<Todo> getTodosContainingText(String text);

    Todo validateAndGetTodo(String id);

    Todo saveTodo(Todo todo);

    void deleteTodo(Todo todo);

    List<Todo> getTodosByUserId(UUID userId);

    List<Todo> getTodosContainingText(UUID userId, String text);
}
