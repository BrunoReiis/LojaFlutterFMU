import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NexusLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const NexusLogo({
    super.key,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/NexusLogo.svg',
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : ColorFilter.mode(
              Theme.of(context).primaryColor,
              BlendMode.srcIn,
            ),
    );
  }
}
