import React from "react";
import { AiOutlineEdit, AiOutlineDelete } from "react-icons/ai";

const TodoList = ({ todos, onEdit, onDelete, onStatusChange }) => {
  return (
    <div className="todos">
      {todos.map((todo) => (
        <div key={todo.id} className="todo">
          <button
            onClick={() => onStatusChange(todo)}
            className="checkbox"
            style={{ backgroundColor: todo.status ? "#A879E6" : "white" }}
          ></button>
          <p>{todo.name}</p>
          <button onClick={() => onEdit(todo)}>
            <AiOutlineEdit size={20} color={"#64697b"}></AiOutlineEdit>
          </button>
          <button onClick={() => onDelete(todo)}>
            <AiOutlineDelete size={20} color={"#64697b"}></AiOutlineDelete>
          </button>
        </div>
      ))}
    </div>
  );
};

export default TodoList;
