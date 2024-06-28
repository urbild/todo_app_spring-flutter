package com.example.todolist_springapi.service;

import com.example.todolist_springapi.model.User;
import com.example.todolist_springapi.repository.TodoRepository;
import com.example.todolist_springapi.exception.TodoNotFoundException;
import com.example.todolist_springapi.model.Todo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class TodoServiceImpl implements TodoService {

    private final TodoRepository todoRepository;

    @Override
    public List<Todo> getTodos() {
        return todoRepository.findAllByOrderByCreatedAtDesc();
    }

    @Override
    public List<Todo> getTodosContainingText(String text) {
        return todoRepository.findByIdContainingOrTodoNameContainingIgnoreCase(text, text);
    }

    @Override
    public Todo validateAndGetTodo(String id) {
        return todoRepository.findById(id)
                .orElseThrow(() -> new TodoNotFoundException(String.format("Todo with id %s not found", id)));
    }

    @Override
    public Todo saveTodo(Todo todo) {
        return todoRepository.save(todo);
    }

    @Override
    public void deleteTodo(Todo todo) {
        todoRepository.delete(todo);
    }

    public List<Todo> getTodosByUserId(UUID userId) {
        return todoRepository.findByUserId(userId);
    }


    public List<Todo> getTodosContainingText(UUID userId, String text) {
        return todoRepository.findByUserIdAndTodoNameContaining(userId, text);
    }

}
