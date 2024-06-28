package com.example.todolist_springapi.repository;


import com.example.todolist_springapi.model.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface TodoRepository extends JpaRepository<Todo, String> {

    List<Todo> findAllByOrderByCreatedAtDesc();

    List<Todo> findByIdContainingOrTodoNameContainingIgnoreCase(String id, String todoName);

    List<Todo> findByUserId(UUID userId);
    List<Todo> findByUserIdAndTodoNameContaining(UUID userId, String todoName);
}
