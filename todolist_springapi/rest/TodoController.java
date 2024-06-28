package com.example.todolist_springapi.rest;

import com.example.todolist_springapi.mapper.TodoMapper;
import com.example.todolist_springapi.model.Todo;
import com.example.todolist_springapi.model.User;
import com.example.todolist_springapi.rest.dto.CreateTodoRequest;
import com.example.todolist_springapi.rest.dto.UpdateTodoRequest;
import com.example.todolist_springapi.rest.dto.TodoDto;
import com.example.todolist_springapi.security.CustomUserDetails;
import com.example.todolist_springapi.security.TokenProvider;
import com.example.todolist_springapi.service.TodoService;
import com.example.todolist_springapi.service.UserService;
import io.jsonwebtoken.Jwt;
import io.jsonwebtoken.Jwts;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.security.oauth2.resource.OAuth2ResourceServerProperties;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import static com.example.todolist_springapi.config.SwaggerConfig.BEARER_KEY_SECURITY_SCHEME;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/todos")
public class TodoController {

    private final UserService userService;
    private final TodoService todoService;
    private final TodoMapper todoMapper;


   /* @Operation(security = {@SecurityRequirement(name = BEARER_KEY_SECURITY_SCHEME)})
    @GetMapping
    public List<TodoDto> getTodos(@RequestParam(value = "text", required = false) String text) {
        List<Todo> todos = (text == null) ? todoService.getTodos() : todoService.getTodosContainingText(text);
        return todos.stream()
                .map(todoMapper::toTodoDto)
                .collect(Collectors.toList());
    }*/

    @GetMapping//("/{username}")
    @Operation(security = {@SecurityRequirement(name = BEARER_KEY_SECURITY_SCHEME)})
    public List<TodoDto> getUserTodos(@RequestParam(value = "text", required = false) String text) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (!(authentication instanceof UsernamePasswordAuthenticationToken)) {
            throw new IllegalStateException("Unexpected authentication type: " + authentication.getClass());
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();

        User user = userService.validateAndGetUserByUsername(username);
        List<Todo> todos = (text == null)
                ? todoService.getTodosByUserId(user.getId())
                : todoService.getTodosContainingText(user.getId(), text);

        return todos.stream()
                .map(todoMapper::toTodoDto)
                .collect(Collectors.toList());
    }


    @Operation(security = {@SecurityRequirement(name = BEARER_KEY_SECURITY_SCHEME)})
    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping
    public TodoDto createTodo(@AuthenticationPrincipal CustomUserDetails currentUser,
                              @Valid @RequestBody CreateTodoRequest createTodoRequest) {
        User user = userService.validateAndGetUserByUsername(currentUser.getUsername());
        Todo todo = todoMapper.toTodo(createTodoRequest);
        todo.setId(UUID.randomUUID().toString());
        todo.setUser(user);
        return todoMapper.toTodoDto(todoService.saveTodo(todo));
    }

    @Operation(security = {@SecurityRequirement(name = BEARER_KEY_SECURITY_SCHEME)})
    @PutMapping("/{id}")
    public TodoDto updateTodo(@PathVariable UUID id,
                              @Valid @RequestBody UpdateTodoRequest updateTodoRequest) {
        Todo todo = todoService.validateAndGetTodo(id.toString());
        todo.setTodoName(updateTodoRequest.getTodoName());
        todo.setCompleted(updateTodoRequest.isCompleted());
        return todoMapper.toTodoDto(todoService.saveTodo(todo));
    }


    @Operation(security = {@SecurityRequirement(name = BEARER_KEY_SECURITY_SCHEME)})
    @DeleteMapping("/{id}")
    public TodoDto deleteTodos(@PathVariable UUID id) {
        Todo todo = todoService.validateAndGetTodo(id.toString());
        todoService.deleteTodo(todo);
        return todoMapper.toTodoDto(todo);
    }
}