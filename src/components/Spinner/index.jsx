import React from 'react';

import './css/spinner.css';

function Spinner() {
  return (
    <div className="spinner">
      <div className="wrapper">
        <div className="ball" />
        <div className="ball" />
        <div className="ball" />
        <div className="ball" />
        <div className="ball" />
      </div>
      <div className="test">
        <h3>Выгрузка информации</h3>
      </div>
    </div>
  );
}

export default Spinner;
