package com.example.todolist_springapi.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.ZonedDateTime;

@Data
@NoArgsConstructor
@Entity
@Table(name = "todos")
public class Todo {

    @Id
    private String id;

    @Column(unique = true)
    private String todoName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private boolean completed;

    private ZonedDateTime createdAt;

    public Todo(String todoName) {
        this.todoName = todoName;
    }

    @PrePersist
    public void onPrePersist() {
        createdAt = ZonedDateTime.now();
    }

}
