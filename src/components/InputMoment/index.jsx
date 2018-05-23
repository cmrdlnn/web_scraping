import React, { Component } from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';

import Calendar from './Calendar';
// import Time from './Time';

import prevMonthIcon from './icons/_ionicons_svg_ios-arrow-round-back.svg';
import nextMonthIcon from './icons/_ionicons_svg_ios-arrow-round-forward.svg';

import './less/input-moment.less';
import './less/variables.less';

class InputMoment extends Component {
  constructor(props) {
    super(props);
    this.state = { tab: 0 };
  }

  handleClickTab = (e, tab) => {
    e.preventDefault();
    this.setState({ tab });
  };

  handleSave = (e) => {
    e.preventDefault();
    if (this.props.onSave) this.props.onSave();
  };

  render() {
    const { tab } = this.state;
    const {
      className,
      hoursStep,
      minutesStep,
      moment,
      onChange,
      onSave,
      saveTitle,
      ...props
    } = this.props;
    const cls = classNames('m-input-moment', className);

    return (
      <div className={cls} {...props}>
        <div className="im-header">{ moment.format('ll') }</div>
        { /*
        <div className="options">
          <button
            className={classNames('im-btn', { 'is-active': tab === 0 })}
            onClick={e => this.handleClickTab(e, 0)}
            type="button"
          >
            Дата
          </button>
          <button
            className={classNames('im-btn', { 'is-active': tab === 1 })}
            onClick={e => this.handleClickTab(e, 1)}
            type="button"
          >
            Время
          </button>
        </div>
        */ }

        <div className="tabs">
          <Calendar
            className={classNames('tab', { 'is-active': tab === 0 })}
            moment={moment}
            nextMonthIcon={nextMonthIcon}
            onChange={onChange}
            prevMonthIcon={prevMonthIcon}
          />
          { /*
          <Time
            className={classNames('tab', { 'is-active': tab === 1 })}
            hoursStep={hoursStep}
            minutesStep={minutesStep}
            moment={moment}
            onChange={onChange}
          />
          */ }
        </div>

        {
          onSave &&
          <button
            type="button"
            className="im-btn btn-save ion-checkmark"
            onClick={this.handleSave}
          >
            { saveTitle }
          </button>
        }
      </div>
    );
  }
}

InputMoment.defaultProps = {
  className: null,
  hoursStep: 1,
  minutesStep: 1,
  onSave: null,
  saveTitle: 'Сохранить',
};

InputMoment.propTypes = {
  className: PropTypes.string,
  hoursStep: PropTypes.number,
  minutesStep: PropTypes.number,
  moment: PropTypes.objectOf(
    PropTypes.any,
  ).isRequired,
  onChange: PropTypes.func.isRequired,
  onSave: PropTypes.func,
  saveTitle: PropTypes.string,
};

export default InputMoment;
