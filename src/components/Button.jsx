import React, { Component } from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';

class Button extends Component {
  logicalEquality = (A, B) => (!A || B) && (A || !B)

  icon = (assignIsLeft, viewIsLeft) => {
    const { assign, icon } = this.props;

    return (
      <span className={classNames(assign, 'icon', 'icon-cloud-download')}>
        <img src={icon} alt="" />
        { this.logicalEquality(assignIsLeft, viewIsLeft) && this.iconContainer() }
      </span>
    );
  }

  title = (assignIsLeft, viewIsLeft) => {
    const { title } = this.props;

    return (
      <span className={classNames(assignIsLeft ? 'right' : 'left', 'title')}>
        { !this.logicalEquality(assignIsLeft, viewIsLeft) && this.iconContainer() }
        { title }
      </span>
    );
  }

  iconContainer = () => {
    const { view } = this.props;

    return view && <span className={view} />;
  }

  render() {
    const { assign, icon, onClick, title, view, ...other } = this.props;

    const assignIsLeft = assign === 'left';
    const viewIsLeft = /.+-left$/.test(view);

    const iconPart = this.icon(assignIsLeft, viewIsLeft);
    const titlePart = this.title(assignIsLeft, viewIsLeft);

    const orderedContent = assignIsLeft ? [iconPart, titlePart] : [titlePart, iconPart];

    return (
      <button
        className={classNames(assign, 'btn')}
        onClick={onClick}
        type="button"
        {...other}
      >
        { orderedContent }
      </button>
    );
  }
}

Button.defaultProps = {
  assign: 'left',
  icon: null,
  view: null,
};

Button.propTypes = {
  assign: PropTypes.oneOf(['left', 'right']),
  icon: PropTypes.string,
  onClick: PropTypes.func.isRequired,
  title: PropTypes.string.isRequired,
  view: PropTypes.oneOf([
    'arrow-left',
    'arrow-right',
    'slant-left',
    'slant-right',
  ]),
};

export default Button;
