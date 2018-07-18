import React, { Component } from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';

import './less/calendar.less';

const Day = ({ i, w, d, className, ...props }) => {
  const prevMonth = w === 0 && i > 7;
  const nextMonth = w >= 4 && i <= 14;
  const cls = classNames({
    'prev-month': prevMonth,
    'next-month': nextMonth,
    'current-day': !prevMonth && !nextMonth && i === d,
  });

  return (
    <td className={cls} {...props}>
      {i}
    </td>
  );
};

Day.defaultProps = {
  className: null,
};

Day.propTypes = {
  className: PropTypes.string,
  d: PropTypes.number.isRequired,
  i: PropTypes.number.isRequired,
  w: PropTypes.number.isRequired,
};

class Calendar extends Component {
  selectDate = (i, w) => {
    const { moment, onChange } = this.props;
    const prevMonth = w === 0 && i > 7;
    const nextMonth = w >= 4 && i <= 14;
    const m = moment;

    if (prevMonth) m.subtract(1, 'month');
    if (nextMonth) m.add(1, 'month');

    m.date(i);

    onChange(m);
  };

  prevMonth = () => {
    this.changeMonth('subtract');
  };

  nextMonth = () => {
    this.changeMonth('add');
  };

  changeMonth = (action) => {
    const { moment, onChange } = this.props;
    onChange(moment[action](1, 'month'));
  };

  render() {
    const { className, moment, nextMonthIcon, prevMonthIcon, weeks } = this.props;
    const d = moment.date();
    const calendar = [];
    const startDay = moment.clone().startOf('month').startOf('week');
    const endDay = moment.clone().endOf('month').endOf('week');
    const date = startDay.clone().subtract(1, 'day');

    while (date.isBefore(endDay, 'day')) {
      calendar.push(
        Array(7).fill(0).map(() => date.add(1, 'day').clone().date()),
      );
    }

    return (
      <div className={classNames('m-calendar', className)}>
        <div className="toolbar">
          <button type="button" className="prev-month" onClick={this.prevMonth}>
            <img src={prevMonthIcon} alt="🡐" />
          </button>
          <span className="current-date">
            { moment.format('MMMM YYYY') }
          </span>
          <button type="button" className="next-month" onClick={this.nextMonth}>
            <img src={nextMonthIcon} alt="🡒" />
          </button>
        </div>

        <table>
          <thead>
            <tr>
              {
                weeks.map((w, i) => (
                  <td key={w}>
                    { w }
                  </td>
                ))
              }
            </tr>
          </thead>

          <tbody>
            {
              calendar.map((row, w) => (
                <tr key={w}>
                  {
                    row.map(i => (
                      <Day
                        key={i}
                        i={i}
                        d={d}
                        w={w}
                        onClick={() => this.selectDate(i, w)}
                      />
                    ))
                  }
                </tr>
              ))
            }
          </tbody>
        </table>
      </div>
    );
  }
}

Calendar.defaultProps = {
  weeks: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
};

Calendar.propTypes = {
  className: PropTypes.string.isRequired,
  moment: PropTypes.objectOf(
    PropTypes.any,
  ).isRequired,
  onChange: PropTypes.func.isRequired,
  prevMonthIcon: PropTypes.string.isRequired,
  nextMonthIcon: PropTypes.string.isRequired,
  weeks: PropTypes.arrayOf(
    PropTypes.string,
  ),
};

export default Calendar;
