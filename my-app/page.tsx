import { addTodo } from "./actions/addTodo"

export default function Home() {
  return (
    <form action={addTodo}>
      <input name="title" />
      <button>Add</button>
    </form>
  )
}
