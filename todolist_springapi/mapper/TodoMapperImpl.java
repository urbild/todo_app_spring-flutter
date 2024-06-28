package com.example.todolist_springapi.mapper;


import com.example.todolist_springapi.model.Todo;
import com.example.todolist_springapi.rest.dto.CreateTodoRequest;
import com.example.todolist_springapi.rest.dto.TodoDto;
import org.springframework.stereotype.Service;

@Service
public class TodoMapperImpl implements TodoMapper {

    @Override
    public Todo toTodo(CreateTodoRequest createTodoRequest) {
        if (createTodoRequest == null) {
            return null;
        }
        return new Todo(createTodoRequest.getTodoName());
    }

    @Override
    public TodoDto toTodoDto(Todo todo) {
        if (todo == null) {
            return null;
        }
        TodoDto.UserDto userDto = new TodoDto.UserDto(todo.getUser().getUsername());
        return new TodoDto(todo.getId(), todo.getTodoName(), userDto, todo.isCompleted(), todo.getCreatedAt());
    }
}
