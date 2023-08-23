import React, { useEffect, useState } from "react";
import axios from "axios";
import "./App.css";
import TodoList from "./TodoList";
import TodoForm from "./TodoForm";

function App() {
  const [todos, setTodos] = useState([]);
  const [inputValue, setInputValue] = useState("");
  const [inputVisibility, setInputVisibility] = useState(false);
  const [selectedTodo, setSelectedTodo] = useState(null);

  useEffect(() => {
    getTodos();
  }, []);

  const getTodos = async () => {
    try {
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/to-do`);
      setTodos(response.data);
    } catch (error) {
      console.error("Error fetching todos:", error);
    }
  };

  const handleNewButtonClick = () => {
    setInputVisibility(!inputVisibility);
    setSelectedTodo(null);
    setInputValue("");
  };

  const handleEditButtonClick = (todo) => {
    setSelectedTodo(todo);
    setInputVisibility(true);
    setInputValue(todo.name);
  };

  const handleInputChange = (event) => {
    setInputValue(event.target.value);
  };

  const createTodo = async () => {
    try {
      await axios.post(`${process.env.REACT_APP_API_URL}/to-do`, {
        name: inputValue,
      });
      getTodos();
      setInputVisibility(false);
      setInputValue("");
    } catch (error) {
      console.error("Error creating todo:", error);
    }
  };

  const editTodo = async () => {
    try {
      await axios.put(`${process.env.REACT_APP_API_URL}/to-do/${selectedTodo.id}`, {
        name: inputValue,
      });
      getTodos();
      setInputVisibility(false);
      setInputValue("");
    } catch (error) {
      console.error("Error editing todo:", error);
    }
  };

  const deleteTodo = async (todo) => {
    try {
      await axios.delete(`${process.env.REACT_APP_API_URL}/to-do/${todo.id}`);
      getTodos();
    } catch (error) {
      console.error("Error deleting todo:", error);
    }
  };

  const toggleStatusTodo = async (todo) => {
    try {
      await axios.put(`${process.env.REACT_APP_API_URL}/to-do/${todo.id}`, {
        status: !todo.status,
      });
      getTodos();
    } catch (error) {
      console.error("Error modifying todo status:", error);
    }
  };

  return (
    <div className="App">
      <header className="container">
        <div className="header">
          <h1>Task list</h1>
        </div>
        <TodoList
          todos={todos}
          onEdit={handleEditButtonClick}
          onDelete={deleteTodo}
          onStatusChange={toggleStatusTodo}
        />
        <TodoForm
          inputValue={inputValue}
          inputVisibility={inputVisibility}
          onInputChange={handleInputChange}
          onSubmit={selectedTodo ? editTodo : createTodo}
          onNewButtonClick={handleNewButtonClick}
        />
      </header>
    </div>
  );
}

export default App;
