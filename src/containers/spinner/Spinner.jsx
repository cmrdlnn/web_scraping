import React from 'react'
import '../css/spinner.css'

function Spinner() {
  return (
    <div class="spinner">
      <div class="wrapper">
        <div class="ball"></div>
        <div class="ball"></div>
        <div class="ball"></div>
        <div class="ball"></div>
        <div class="ball"></div>
      </div>
      <div class="test">
        <h3>Парсинг контента</h3>
      </div>
    </div>
  )
}

export default Spinner
