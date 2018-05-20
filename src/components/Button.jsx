import React, { Component } from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';

class Button extends Component {
  icon = (isLeft) => {
    const { icon, assign } = this.props;

    return (
      <span className={classNames(assign, 'icon', 'icon-cloud-download')}>
        { isLeft && this.iconContainer() }
        <img src={icon} alt="" />
      </span>
    );
  }

  title = (isLeft) => {
    const { title } = this.props;

    return (
      <span className={classNames(isLeft ? 'right' : 'left', 'title')}>
        { !isLeft && this.iconContainer() }
        { title }
      </span>
    );
  }

  iconContainer = () => {
    const { type } = this.props;
    return type && <span className={type} />;
  }

  render() {
    const { onClick, assign } = this.props;
    const isLeft = assign === 'left';
    const orderedContent = isLeft
      ? [this.icon(isLeft), this.title(isLeft)]
      : [this.title(), this.icon()];

    return (
      <button className={classNames(assign, 'btn')} onClick={onClick}>
        { orderedContent }
      </button>
    );
  }
}

Button.defaultProps = {
  assign: 'left',
  icon: null,
  type: null,
};

Button.propTypes = {
  assign: PropTypes.oneOf(['left', 'right']),
  icon: PropTypes.string,
  onClick: PropTypes.func.isRequired,
  title: PropTypes.string.isRequired,
  type: PropTypes.oneOf([
    'arrow-left',
    'arrow-right',
    'slant-left',
    'slant-right',
  ]),
};

export default Button;
