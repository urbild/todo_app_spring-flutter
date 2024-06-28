package com.example.todolist_springapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.CrossOrigin;

@SpringBootApplication
@CrossOrigin
public class SpringTodolistApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringTodolistApplication.class, args);
	}

}
