import React, { Component } from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';

import range from 'lodash/range';
import chunk from 'lodash/chunk';

import './less/calendar.less';

const Day = ({ i, w, d, className, ...props }) => {
  const prevMonth = w === 0 && i > 7;
  const nextMonth = w >= 4 && i <= 14;
  const cls = classNames({
    'prev-month': prevMonth,
    'next-month': nextMonth,
    'current-day': !prevMonth && !nextMonth && i === d,
  });

  return <td className={cls} {...props}>{i}</td>;
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
    const prevMonth = w === 0 && i > 7;
    const nextMonth = w >= 4 && i <= 14;
    const m = this.props.moment;

    if (prevMonth) m.subtract(1, 'month');
    if (nextMonth) m.add(1, 'month');

    m.date(i);

    this.props.onChange(m);
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
    const { moment, nextMonthIcon, prevMonthIcon, weeks } = this.props;
    const d = moment.date();
    const d1 = moment.clone().subtract(1, 'month').endOf('month').date();
    const d2 = moment.clone().date(1).day();
    const d3 = moment.clone().endOf('month').date();
    const days = [].concat(
      range((d1 - d2) + 1, d1 + 1),
      range(1, d3 + 1),
      range(1, ((42 - d3) - d2) + 1),
    );

    return (
      <div className={classNames('m-calendar', this.props.className)}>
        <div className="toolbar">
          <button type="button" className="prev-month" onClick={this.prevMonth}>
            <img src={prevMonthIcon} alt="🡐" />
          </button>
          <span className="current-date">{moment.format('MMMM YYYY')}</span>
          <button type="button" className="next-month" onClick={this.nextMonth}>
            <img src={nextMonthIcon} alt="🡒" />
          </button>
        </div>

        <table>
          <thead>
            <tr>
              {weeks.map((w, i) => <td key={i}>{w}</td>)}
            </tr>
          </thead>

          <tbody>
            {
              chunk(days, 7).map((row, w) => (
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
