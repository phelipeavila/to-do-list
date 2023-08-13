import React from "react";

const TodoForm = ({
  inputValue,
  inputVisibility,
  onInputChange,
  onSubmit,
  onNewButtonClick,
}) => {
  return (
    <>
      <input
        value={inputValue}
        style={{ display: inputVisibility ? "block" : "none" }}
        onChange={onInputChange}
        className="inputName"
      ></input>
      <button
        onClick={inputVisibility ? onSubmit : onNewButtonClick}
        className="newTaskButton"
      >
        {inputVisibility ? "Confirm" : "+ New task"}
      </button>
    </>
  );
};

export default TodoForm;
