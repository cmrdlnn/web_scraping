import React, { Component } from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';

import InputSlider from 'react-input-slider';

import './less/time.less';

class Time extends Component {
  changeHours = ({ x }) => {
    this.changeTime(x, 'hours');
  };

  changeMinutes = ({ x }) => {
    this.changeTime(x, 'minutes');
  };

  changeTime = (x, timePart) => {
    const { moment, onChange } = this.props;
    moment[timePart](x);
    onChange(moment);
  }

  render() {
    const {
      className,
      hoursStep,
      hoursTitle,
      minutesStep,
      minutesTitle,
      moment,
    } = this.props;

    return (
      <div className={classNames('m-time', className)}>
        <div className="showtime">
          <span className="time">
            { moment.format('HH') }
          </span>
          <span className="separater">
            :
          </span>
          <span className="time">
            { moment.format('mm') }
          </span>
        </div>

        <div className="sliders">
          <div className="time-text">
            { hoursTitle }
          </div>
          <InputSlider
            className="u-slider-time"
            xmin={0}
            xmax={23}
            xstep={hoursStep}
            x={moment.hour()}
            onChange={this.changeHours}
          />
          <div className="time-text">
            { minutesTitle }
          </div>
          <InputSlider
            className="u-slider-time"
            xmin={0}
            xmax={59}
            xstep={minutesStep}
            x={moment.minute()}
            onChange={this.changeMinutes}
          />
        </div>
      </div>
    );
  }
}

Time.defaultProps = {
  hoursStep: 1,
  hoursTitle: 'Часы:',
  minutesStep: 1,
  minutesTitle: 'Минуты:',
};

Time.propTypes = {
  className: PropTypes.string.isRequired,
  hoursStep: PropTypes.number,
  hoursTitle: PropTypes.string,
  minutesStep: PropTypes.number,
  minutesTitle: PropTypes.string,
  moment: PropTypes.objectOf(
    PropTypes.any,
  ).isRequired,
  onChange: PropTypes.func.isRequired,
};

export default Time;
