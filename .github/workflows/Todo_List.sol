// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TodoList{
    struct Todo{
        string text;
        bool completed;
    }
    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo({
            text: _text,
            completed: false
        }));
    }

    function updateText(uint _index, string calldata _text) external {
        todos[_index].text = _text;         // Eğer küçük bir işlemimiz varsa bu kod daha az gaz yakar

        // Todo.storage todo = todos[_index];  // Yukarıdaki tek satırlık kod ile bu kod aynı işlevi görür
        // todo.text = _text                   // Eğer çoğu kez kullanacaksak bu 2 satırlık kodu kullanmalıyız
    }

    function get(uint _index) external view returns (string memory, bool){// Normalde bu fonksiyona gerek yok fakat pratik için yazıyorum
        Todo memory todo = todos[_index];
        return(todo.text,todo.completed);
    } 

    function toggleCompleted(uint _index) external {
        todos[_index].completed = !todos[_index].completed;  // Doğru ya da yanlış olduğunu kontrol edip değiştiriyoruz
    }
}
